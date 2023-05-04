
require(data.table)
require(tidyverse)
require(gdxtools)
require(witchtools)
require(ggpubr)

file_directory <- "~/GitHub/climate-change/Italy"
complete_directory <- here::here()
all_gdx <- c(Sys.glob(here::here(file_directory,"results_*.gdx")))

igdx('C:/GAMS/42')

osemosys_sanitize <- function(.x) {
  .x[, scen := basename(gdx)]
  .x[, scen := str_replace(scen,"results_","")]
  .x[, scen := str_replace(scen,".gdx","")]
  .x[, gdx := NULL]}


################################################################################
########### PLOT EMISSIONS #####################################################
################################################################################

emissions <- batch_extract("ANNUALEMISSIONS",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
{
  x11()
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
  x11()
  ggplot(prod2[prod2$value!=0,]) +
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
  x11()
  ggplot(cap2[cap2$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() 
}

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
  x11()
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
  x11()
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
  x11()
  ggplot(water2[water2$value!=0 & water2$TECH!='HY',]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    labs(title = "Use of water by technology (excepted hydroelectrical)") +
    xlab("year") + ylab("Water used [ML]") + theme_pubr() 
}

################################################################################
########### PLOT COMPARE WATER USAGE & HYDROELECTRICAL POWER ###################
################################################################################

{
  x11()
  ggplot(water[water$FUEL=='HY',]) +
    geom_line(aes(x=as.numeric(YEAR),y=value), linewidth=1.5, color='blue') +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Water used [ML]") + theme_pubr() 
}

<<<<<<< Updated upstream
################################################################################
########### PLOT STORAGE USAGE ###################################################
################################################################################

storage <- batch_extract("STORAGELEVELDAYTYPESTART",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
storage = storage[storage$STORAGE=='DAM' | storage$STORAGE=='H2' | storage$STORAGE=='BAT']

{
  x11()
  ggplot(storage) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=STORAGE), linewidth=0.5) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() 
=======
totcap3=totcap2[totcap2$TECH=='HY',]
{
  x11()
  ggplot(totcap3) +
    geom_line(aes(x=as.numeric(YEAR),y=value), linewidth=1.5, color='red') +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Hydroelectrical capacity installed [GW]") + theme_pubr() 
}

################################################################################
########### PLOT WATER AVAILABILITY ############################################
################################################################################

#TOTAL USAGE OF WATER
ok <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
ok = ok[ok$FUEL=="HY"]
ok = ok[ok$TECHNOLOGY=='RIVER']
# ok=ok[ok$scen %in% c('drought0', 'drought10%', 'drought20%'),]

{
  x11()
  ggplot(ok) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1.3) +
    labs(title = "Water given by RIVER") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Water [ML]") + theme_pubr() 
}


################################################################################
########### PLOT     ############################################
################################################################################

use2 <- batch_extract("USEANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
use2 = use2[use2$FUEL=="HY",]

{
  x11()
  ggplot(use2) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1.3) +
    labs(title = "Total Water Usage") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Water [ML]") + theme_pubr() 
>>>>>>> Stashed changes
}
