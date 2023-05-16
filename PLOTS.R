
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

directory_graphs = "~/GitHub/climate-change/Italy/Graphs/"


prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

prod$TECH=prod$TECHNOLOGY
for(i in unique(prod$TECHNOLOGY)){
  prod$TECH[prod$TECH==i] = substr(i, start=1, stop=2)
}

legend = cbind(unique(prod$TECH), c("BioFuel", "Biomass", "Coal", "Trasformator", "Geothermal", "HevayFuel",
                           "Hydro", "NaturalGas", "Tidal", "Oil", "Solar", "Wind", "Waste",
                           "Nuclear", "Uranium", "Batteries", "River", "Sea", "Delta"))

for(i in 1:length(legend[,1])){
  prod$TECH[prod$TECH==legend[i,1]] = legend[i,2]
}

################################################################################
########### PLOT EMISSIONS #####################################################
################################################################################

emissions <- batch_extract("ANNUALEMISSIONS",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
emissions = emissions[emissions$YEAR <= 2050,]
emissions = emissions[emissions$scen != 'base']

emi_cap <- batch_extract("AnnualEmissionLimit",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

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

{
  x11()
  p = ggplot(emissions |> filter(EMISSION=="CO2")) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1)+ 
    geom_line(data = emi_cap, aes(x=as.numeric(YEAR),y=value),color="red" ,  linewidth=1)+ 
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

prod3_NoNuke = prod3[prod3$scen=="BH85",]
{
  x11()
  p = ggplot(prod3_NoNuke) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"ProductionByTechnologyNoNuke.png"), p)
}

prod3_Nuke = prod3[prod3$scen=="NH85",]
{
  x11()
  p = ggplot(prod3_Nuke) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"ProductionByTechnologyNuke.png"), p)
}

################################################################################
########### PLOT USE OF WATER FROM PRODUCTION BY TECHNOLOGY ####################
################################################################################

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
prod = prod[prod$FUEL=="E1" | prod$FUEL=='E2',]
prod = prod[ prod$TECHNOLOGY  != "EL00TD0",]
prod[prod$FUEL=="E1",]$value = 0.95*prod[prod$FUEL=="E1",]$value
prod = prod[ prod$value  != 0,]

input <- batch_extract("InputActivityRatio",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
input=input[input$YEAR=="2040" & input$MODE_OF_OPERATION=="1" & input$FUEL=="HY" & input$TECHNOLOGY!="DELTA",]
output <- batch_extract("OutputActivityRatio",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
output=output[output$YEAR=="2040" & output$MODE_OF_OPERATION=="1" & output$FUEL=="HY" & output$TECHNOLOGY!="RIVER",]

prod$WATER = prod$value 
for(i in unique(prod$TECHNOLOGY)){
  prod$WATER[prod$TECHNOLOGY==i] = prod$value * (input[input$TECHNOLOGY==i,]$value - output[output$TECHNOLOGY==i,]$value)
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
cap3 = cap3[cap3$TECH != 'SE',]


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
totcap = totcap[totcap$value<99999,]
totcap = totcap[totcap$TECHNOLOGY!='RIVER',]
totcap = totcap[totcap$TECHNOLOGY!='SEA',]
totcap = totcap[totcap$TECHNOLOGY!='DELTA' & totcap$TECHNOLOGY!='BATCHG' & totcap$TECHNOLOGY!='OI00X00',]


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
    labs(title="Total Installed Capacity")
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"TotalCapacity.png"), p)
}

################################################################################
########### PLOT WATER USAGE ###################################################
################################################################################

#WATER USED BY TECH
water_use <- batch_extract("USEBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
water_prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

water2 = water_prod
water2$value = water_use$value - water_prod$value
water2 = water2[water2$FUEL=='HY',]
water2 = water2[water2$TECH!='DELTA' & water2$TECH!='RIVER',]

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
  p = ggplot(water2[water2$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    labs(title = "Use of water by technology") +
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


storage$DATE = as.numeric(storage$YEAR) + 0.2*as.numeric(storage$SEASON)
{
  x11()
  p = ggplot(storage) +
    geom_line(aes(x=as.numeric(DATE),y=value,color=STORAGE), linewidth=0.5) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))

  print(p)
  ggsave(paste0(directory_graphs,"StorageUsage.png"), p)
}

storage_BH26 = storage[storage$scen == "BH26",]
{
  x11()
  p = ggplot(storage_BH26) +
    geom_line(aes(x=as.numeric(DATE),y=value,color=STORAGE), linewidth=1.3) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"StorageUsage_BH26.png"), p)
}

storage_BH85 = storage[storage$scen == "BH85",]
{
  x11()
  p = ggplot(storage_BH85) +
    geom_line(aes(x=as.numeric(DATE),y=value,color=STORAGE), linewidth=1.3) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"StorageUsage_BH85.png"), p)
}

storage_NH26 = storage[storage$scen == "NH26",]
{
  x11()
  p = ggplot(storage_NH26) +
    geom_line(aes(x=as.numeric(DATE),y=value,color=STORAGE), linewidth=1.3) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"StorageUsage_NH26.png"), p)
}

storage_NH85 = storage[storage$scen == "NH85",]
{
  x11()
  p = ggplot(storage_NH85) +
    geom_line(aes(x=as.numeric(DATE),y=value,color=STORAGE), linewidth=1.3) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"StorageUsage_NH85.png"), p)
}

storage = storage[storage$STORAGE != "BAT",]
{
  x11()
  p = ggplot(storage) +
    geom_line(aes(x=as.numeric(DATE),y=value,color=scen), linewidth=1.3) +
    #facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"StorageUsage.png"), p)
}

storage_85 = storage[storage$scen == "BL85" | storage$scen == "BM85" | storage$scen == "BH85" |
                       storage$scen == "NL85" | storage$scen == "NM85" | storage$scen == "NH85",]
{
  x11()
  p = ggplot(storage_85) +
    geom_line(aes(x=as.numeric(DATE),y=value,color=scen), linewidth=1.3) +
    #facet_wrap(scen~.,) +
    labs(title = "Adaptation to RCP 8.5") +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"StorageUsage_85.png"), p)
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

use2_85 = use2[use2$scen == "BL85" | use2$scen == "BM85" | use2$scen == "BH85" |
                 use2$scen == "NL85" | use2$scen == "NM85" | use2$scen == "NH85",]
{
  x11()
  p = ggplot(use2_85) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1.3) +
    #facet_wrap(scen~.,) +
    labs(title = "Adaptation to RCP 8.5") +
    xlab("year") + ylab("Fresh water used [10^9 m3]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) + 
    ylim(0,600)
  print(p)
  ggsave(paste0(directory_graphs,"TotalWaterUsage_85.png"), p)
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

opcost <- batch_extract("OPERATINGCOST",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
capinv <- batch_extract("CAPITALINVESTMENT",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

opcost = opcost |> 
  group_by(scen,YEAR) |>
  summarise(value = sum(value))

capinv = capinv |> 
  group_by(scen,YEAR) |>
  summarise(value = sum(value))

cost = opcost 
cost$value = opcost$value + capinv$value

cost = cost[cost$scen != 'base',]

{
  x11()
  p = ggplot(cost) +
    geom_line(aes(x=as.numeric(YEAR),y=value/1000,color=scen), linewidth=1.3) +
  #  geom_line(data = opcost, aes(x=as.numeric(YEAR),y=value/1000,color=scen), lty=2 ,linewidth=1.3) +
  #  geom_line(data = capinv, aes(x=as.numeric(YEAR),y=value/1000,color=scen), lty=3 ,linewidth=1.3) +
    labs(title = "Total annual cost") +
    xlab("year") + ylab("Cost [BIllions of $]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  print(p)
}


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


z = cost |> 
  group_by(NUCLEAR, YEAR) |>
  summarise(value = mean(value))


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

################################################################################
########### PLOT PIE CHARTS ####################################################
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

prod2050 = prod3[prod3$YEAR==2050,]
prod2015 = prod3[prod3$YEAR==2015 & prod3$scen==prod3[1,]$scen,]


{
  x11()
  p = ggplot(prod2015, aes(x = "", y = value_perc, fill = TECH)) +
    geom_bar(stat = "identity", width = 1, color='black') +
    geom_segment(aes(x = 0, y = 0, xend = 0, yend = value_perc), color = "black", size = 0.5) +
    coord_polar("y", start = 0) +
    # facet_wrap(scen~.,) +
    # scale_fill_brewer(palette="Paired") +
    labs(fill = "Technology", title = "Productive Mix in 2015") +
    ylab("") + xlab("") +
    geom_text(data =prod2015[prod2015$value_perc>=1e-2,], aes(label = paste0(round(value_perc*100), "%")), position = position_stack(vjust = 0.5)) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"MixProduttivoPie2015.png"), p)
}

{
  x11()
  p = ggplot(prod2050, aes(x = "", y = value_perc, fill = TECH)) +
    geom_bar(stat = "identity", width = 1, color='black') +
    geom_segment(aes(x = 0, y = 0, xend = 0, yend = value_perc), color = "black", size = 0.5) +
    coord_polar("y", start = 0) +
    facet_wrap(scen~.,) +
    # scale_fill_brewer(palette="Paired") +
    labs(fill = "Technology", title = "Productive Mix in 2050") +
    ylab("") + xlab("") +
    geom_text(data =prod2050[prod2050$value_perc>=1e-2,], aes(label = paste0(round(value_perc*100), "%")), position = position_stack(vjust = 0.5)) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"MixProduttivoPie2015.png"), p)
}

################################################################################
########### PLOT SPECIFICS PIE CHARTS ##########################################
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

for(i in 1:length(legend[,1])){
  prod3$TECH[prod3$TECH==legend[i,1]] = legend[i,2]
}

# 2015 BH85
prod2015 = prod3[prod3$YEAR=='2015' & prod3$scen=='BH85',]

{
  x11()
  p = ggplot(prod2015, aes(x = "", y = value_perc, fill = TECH)) +
    geom_bar(stat = "identity", width = 1, color='black') +
    geom_segment(aes(x = 0, y = 0, xend = 0, yend = value_perc), color = "black", size = 0.5) +
    coord_polar("y", start = 0) +
    # facet_wrap(scen~.,) +
    # scale_fill_brewer(palette="Paired") +
    labs(fill = "Technology", title = "Productive Mix in 2015 BH85") +
    scale_fill_brewer(palette="Paired") +
    ylab("") + xlab("") +
    geom_text(data =prod2015[prod2015$value_perc>=1e-2,], aes(label = paste0(round(value_perc*100), "%")), position = position_stack(vjust = 0.5)) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5),
          axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank())
  
  print(p)
  ggsave(paste0(directory_graphs,"PieBH85_2015.png"), p)
}
# 2050 BH85
prod2015 = prod3[prod3$YEAR=='2050' & prod3$scen=='BH85',]

{
  x11()
  p = ggplot(prod2015, aes(x = "", y = value_perc, fill = TECH)) +
    geom_bar(stat = "identity", width = 1, color='black') +
    geom_segment(aes(x = 0, y = 0, xend = 0, yend = value_perc), color = "black", size = 0.5) +
    coord_polar("y", start = 0) +
    # facet_wrap(scen~.,) +
    # scale_fill_brewer(palette="Paired") +
    labs(fill = "Technology", title = "Productive Mix in 2050 BH85") +
    scale_fill_brewer(palette="Paired") +
    ylab("") + xlab("") +
    geom_text(data =prod2015[prod2015$value_perc>=1e-2,], aes(label = paste0(round(value_perc*100), "%")), position = position_stack(vjust = 0.5)) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5),
          axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank())
  
  print(p)
  ggsave(paste0(directory_graphs,"PieBH85_2050.png"), p)
}
# 2015 NH85
prod2015 = prod3[prod3$YEAR=='2015' & prod3$scen=='NH85',]

{
  x11()
  p = ggplot(prod2015, aes(x = "", y = value_perc, fill = TECH)) +
    geom_bar(stat = "identity", width = 1, color='black') +
    geom_segment(aes(x = 0, y = 0, xend = 0, yend = value_perc), color = "black", size = 0.5) +
    coord_polar("y", start = 0) +
    # facet_wrap(scen~.,) +
    # scale_fill_brewer(palette="Paired") +
    labs(fill = "Technology", title = "Productive Mix in 2015 NH85") +
    scale_fill_brewer(palette="Paired") +
    ylab("") + xlab("") +
    geom_text(data =prod2015[prod2015$value_perc>=1e-2,], aes(label = paste0(round(value_perc*100), "%")), position = position_stack(vjust = 0.5)) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5),
          axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank())
  
  print(p)
  ggsave(paste0(directory_graphs,"PieNH85_2015.png"), p)
}
# 2050 NH85
prod2015 = prod3[prod3$YEAR=='2050' & prod3$scen=='NH85',]

{
  x11()
  p = ggplot(prod2015, aes(x = "", y = value_perc, fill = TECH)) +
    geom_bar(stat = "identity", width = 1, color='black') +
    geom_segment(aes(x = 0, y = 0, xend = 0, yend = value_perc), color = "black", size = 0.5) +
    coord_polar("y", start = 0) +
    # facet_wrap(scen~.,) +
    # scale_fill_brewer(palette="Paired") +
    labs(fill = "Technology", title = "Productive Mix in 2050 NH85") +
    scale_fill_brewer(palette="Paired") +
    ylab("") + xlab("") +
    geom_text(data =prod2015[prod2015$value_perc>=1e-2,], aes(label = paste0(round(value_perc*100), "%")), position = position_stack(vjust = 0.5)) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5),
          axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank())
  
  print(p)
  ggsave(paste0(directory_graphs,"PieNH85_2050.png"), p)
}

#7A9DA9



