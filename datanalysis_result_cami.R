#File analisi dati di Lorenzo
setwd("/Users/cami/Documents/GitHub/climate-change/Italy")
library(data.table)
require(witchtools)
require(ggpubr)
library(tidyverse)
library(gdxtools)

igdx('/Library/Frameworks/GAMS.framework/Versions/42/Resources')
file_directory <- "Italy"
complete_directory <- here::here()
complete_directory
#"/Users/cami/Documents/GitHub/climate-change"
all_gdx <- c(Sys.glob(here::here(file_directory,"results_*.gdx")))
all_gdx

osemosys_sanitize <- function(.x) {
  .x[, scen := basename(gdx)]
  .x[, scen := str_replace(scen,"results_","")]
  .x[, scen := str_replace(scen,".gdx","")]
  .x[, gdx := NULL]
  # .x[, V1 := NULL]
}

################################################################################
########### PLOT SHARE OF FUEL USED ############################################
################################################################################

# storaged_water <- batch_extract("STORAGELEVELYEARFINISH",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
# {x11()
#   ggplot(storaged_water) +
#     geom_line(aes(x=as.numeric(YEAR),y=value,color=scen))
# }

################################################################################
########### PLOT EMISSIONS #####################################################
################################################################################

emissions <- batch_extract("ANNUALEMISSIONS",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
{
  quartz()
  ggplot(emissions |> filter(EMISSION=="CO2")) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen))+ 
    labs(title = "Emissions [Mton/yr]",subtitle = "Only emissions of CO2", x = "year", y = "Emission [MtonCo2]") +
    theme_bw()
}

################################################################################
########### PLOT PRODUCTION BY TECHNOLOGY ######################################
################################################################################

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
prod = prod[prod$FUEL=="E1" | prod$FUEL=='E2',]
#prod = prod[prod$FUEL=='E2',]
prod = prod[ prod$TECHNOLOGY  != "EL00TD0",]
prod[prod$FUEL=="E1",]$value = 0.95*prod[prod$FUEL=="E1",]$value

prod$TECH=prod$TECHNOLOGY
for(i in unique(prod$TECHNOLOGY)){
  prod$TECH[prod$TECH==i] = substr(i, start=1, stop=2)
}

prod2 = prod |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
prod2$value = round(as.numeric(prod2$value),2)
#prod2$value = as.numeric(prod2$value)

demand <- batch_extract("SpecifiedAnnualDemand",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
demand = demand[demand$FUEL=="E2",]

use <- batch_extract("USEANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
use = use[use$FUEL=='E2',]
demand$value = demand$value + use$value

for (i in 2051:2060){
  prod2=prod2[prod2$YEAR!=i,]
  demand=demand[demand$YEAR!=i,]
}

{
  quartz()
  ggplot(prod2) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    geom_line(data=demand, aes(x=as.numeric(YEAR),y=value), linewidth=1.2) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() 
}

################################################################################
########### PLOT ACCUMULATED CAPACITY ##########################################
################################################################################

cap <- batch_extract("ACCUMULATEDNEWCAPACITY",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
cap = cap[cap$value!=99999]

temp = cap$TECHNOLOGY
cap$TECH=temp

for(i in unique(temp)){
  cap$TECH[cap$TECH==i] = substr(i, start=1, stop=2)
}

cap2 = cap |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
cap2$value = round(as.numeric(cap2$value),2)

{
  quartz()
  ggplot(cap2[cap2$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Accumulated capacity [GW]", subtitle = "Accumulated installed capacity by technology") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() 
}

################################################################################
########### PLOT AMOUNT OF ENERGY PER FUEL #####################################
################################################################################
prod <- batch_extract("PRODUCTIONBYTECHNOLOGY",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

temp = prod$TECHNOLOGY
prod$TECH=temp

for(i in unique(temp)){
  prod$TECH[prod$TECH==i] = substr(i, start=1, stop=2)
}

prod2 = prod |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
prod2$value = round(as.numeric(prod2$value),2)

{
  quartz()
  ggplot(prod2[prod2$value!=0,]) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=TECH)) +
    facet_wrap(scen~.,) + 
    labs(title = "Production of energy by technology") +
    xlab("year") + ylab("Production [GW]") + theme_pubr() 
}

################################################################################
################################################################################
########### PLOT TOTAL CAPACITY ##########################################
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

{
  quartz()
  ggplot(totcap2[totcap2$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() 
}

################################################################################
########### PLOT AMOUNT OF ENERGY PER FUEL #####################################
################################################################################

prod3=prod2
for(i in unique(prod3$TECH)){
  if( sum(prod3[prod3$TECH==i,]$value == 0) ==0 ){
    prod3 = prod3[prod3$TECH!=i,]
  }
}

{
  quartz()
  ggplot(prod3) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=TECH), linewidth=1.2) +
    facet_wrap(scen~.,) + 
    labs(title = "Production of energy by technology") +
    xlab("year") + ylab("Production [PJ]") + theme_pubr()  
}


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

{
  quartz()
  ggplot(water2[water2$value!=0 & water2$TECH!='HY',]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    labs(title = "Use of water by technology (excepted hydroelectrical)") +
    xlab("year") + ylab("Water used [km3]") + theme_pubr() 
}

################################################################################
########### PLOT COMPARE WATER USAGE & HYDROELECTRICAL POWER ###################
################################################################################

{
  quartz()
  ggplot(water[water$FUEL=='HY',]) +
    geom_line(aes(x=as.numeric(YEAR),y=value), linewidth=1.5, color='blue') +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Water used [ML]") + theme_pubr() 
}

################################################################################
########### PLOT STORAGE USAGE ###################################################
################################################################################

storage2 <- batch_extract("RATEOFSTORAGECHARGE",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
# storage = storage[storage$STORAGE=='DAM' | storage$STORAGE=='H2' | storage$STORAGE=='BAT']

storage2 = storage2 |> 
  group_by(scen,SEASON, DAILYTIMEBRACKET,YEAR) |>
  summarise(value = sum(value))
# storage2$value = round(as.numeric(water2$value),2)

storage2 = storage2[storage2$scen=="base",]
{
  quartz()
  ggplot(storage2) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=DAILYTIMEBRACKET), linewidth=1.5) +
    facet_wrap(SEASON~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() 
}


storage3 <- batch_extract("RATEOFSTORAGEDISCHARGE",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
# storage = storage[storage$STORAGE=='DAM' | storage$STORAGE=='H2' | storage$STORAGE=='BAT']

storage3 = storage3 |> 
  group_by(scen,SEASON, DAILYTIMEBRACKET,YEAR) |>
  summarise(value = sum(value))
# storage3$value = round(as.numeric(water2$value),2)

storage3 = storage3[storage3$scen=="base",]
{
  quartz()
  ggplot(storage3) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=DAILYTIMEBRACKET), linewidth=1.5) +
    facet_wrap(SEASON~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() 
}

################################################################################
########### PLOT STORAGE USAGE ###################################################
################################################################################

storage <- batch_extract("STORAGELEVELSEASONSTART",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
storage = storage[storage$STORAGE=='DAM' | storage$STORAGE=='H2' | storage$STORAGE=='BAT']

{
  quartz()
  ggplot(storage) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=STORAGE), linewidth=0.5) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() 
}

# =======

totcap3=totcap2[totcap2$TECH=='HY',]
{
  quartz()
  ggplot(totcap3) +
    geom_line(aes(x=as.numeric(YEAR),y=value), linewidth=1.5, color='red') +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Hydroelectrical capacity installed [GW]") + theme_pubr() 
}

################################################################################
########### PLOT     ############################################
################################################################################

use2 <- batch_extract("USEANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
use2 = use2[use2$FUEL=="HY",]

{
  quartz()
  ggplot(use2) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1.3) +
    labs(title = "Total Water Usage") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Water [km3]") + theme_pubr() 
}


################################################################################
########### PLOT     ############################################
################################################################################

cost <- batch_extract("OPERATINGCOST",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

cost = cost |> 
  group_by(scen,YEAR) |>
  summarise(value = sum(value))
# storage3$value = round(as.numeric(water2$value),2)

{
  quartz()
  ggplot(cost) +
    geom_line(aes(x=as.numeric(YEAR),y=value/1000,color=scen), linewidth=1.3) +
    labs(title = "Operating cost") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Cost [BIllions of $]") + theme_pubr() 
  }

z <- batch_extract("z",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

##########################################################################
########### PLOT COSTO ###################################################
##########################################################################


prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
prod = prod[prod$FUEL=="E1" | prod$FUEL=='E2',]
prod = prod[ prod$TECHNOLOGY  != "EL00TD0",]
prod[prod$FUEL=="E1",]$value = 0.95*prod[prod$FUEL=="E1",]$value

prod$TECH=prod$TECHNOLOGY
for(i in unique(prod$TECHNOLOGY)){
  prod$TECH[prod$TECH==i] = substr(i, start=1, stop=2)
}

prod2 = prod |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
prod2$value = round(as.numeric(prod2$value),2)

demand <- batch_extract("SpecifiedAnnualDemand",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

{
  quartz()
  ggplot(prod2[prod2$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    geom_line(data=demand, aes(x=as.numeric(YEAR),y=value), linewidth=1.2) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() 
}



################################################################################
########### PLOT CARBON CAPTURE ######################################
################################################################################

prod4 <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
prod4 = prod4[prod4$TECHNOLOGY=='COCSPN2' | prod4$TECHNOLOGY=='NGCSPN2' | prod4$TECHNOLOGY=='BMCSPN2',]
prod4 = prod4[prod4$FUEL=='E2' | prod4$FUEL=='E1',]
prod4[prod4$FUEL=="E1",]$value = 0.95*prod4[prod4$FUEL=="E1",]$value


{
  quartz()
  ggplot(prod4[prod4$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECHNOLOGY)) +
    labs(title = "prod4uction by Technology [PJ/yr]", subtitle = "Energy prod4uction by set of technology using the same fuel") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() 
}


################################################################################
########### PLOT ACCUMULATED CAPACITY ##########################################
################################################################################

