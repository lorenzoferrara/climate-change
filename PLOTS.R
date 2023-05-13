
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


################################################################################
########### PLOT EMISSIONS #####################################################
################################################################################

emissions <- batch_extract("ANNUALEMISSIONS",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
{
  x11()
  ggplot(emissions |> filter(EMISSION=="CO2")) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1)+ 
    labs(title = "Emissions [Mton/yr]",subtitle = "Only emissions of CO2", x = "year", y = "Emission [MtonCo2]") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
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
  ggplot(prod3) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
}

{
  x11()
  ggplot(prod3) +
    geom_area(aes(x=as.numeric(YEAR),y=value_perc,fill=TECH)) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
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

{
  x11()
  ggplot(cap3) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() 
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

{
  x11()
  ggplot(totcap2[totcap2$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() +
    scale_fill_brewer(palette="Paired")
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
    xlab("year") + ylab("Water used [km3]") + theme_pubr() 
}

################################################################################
########### PLOT STORAGE USAGE ###################################################
################################################################################

storage <- batch_extract("STORAGELEVELSEASONSTART",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
storage = storage[storage$STORAGE=='DAM' | storage$STORAGE=='H2' | storage$STORAGE=='BAT']

{
  x11()
  ggplot(storage) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=STORAGE), linewidth=0.5) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() 
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
    xlab("year") + ylab("Water [km3]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
}


################################################################################
########### PLOT COST ##########################################################
################################################################################

cost <- batch_extract("OPERATINGCOST",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

cost = cost |> 
  group_by(scen,YEAR) |>
  summarise(value = sum(value))
# storage3$value = round(as.numeric(water2$value),2)

{
  x11()
  ggplot(cost) +
    geom_line(aes(x=as.numeric(YEAR),y=value/1000,color=scen), linewidth=1.3) +
    labs(title = "Operating cost") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Cost [BIllions of $]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  }

cost$value_cum = cost$value
for(year in unique(cost$YEAR)){
  for(scenario in unique(cost$scen)){
    cost[cost$YEAR==year & cost$scen==scenario,]$value_cum = sum( cost[cost$YEAR<=year & cost$scen==scenario ,]$value )
  }
}


#COSTS
{
  x11()
  ggplot(cost) +
    geom_line(aes(x=as.numeric(YEAR),y=value/1000,color=scen), linewidth=1.3) +
    labs(title = "Operating Cost") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Cost [BIllions of $]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
}

#CUMULATIVE COSTS
{
  x11()
  ggplot(cost) +
    geom_line(aes(x=as.numeric(YEAR),y=value_cum,color=scen), linewidth=1.3) +
    labs(title = "Cumulative Operating Cost") +
    # scale_y_continuous(trans='log2') +
    # scale_x_continuous(trans='log2') +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Cost [BIllions of $]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
}

################################################################################
########### PLOT CARBON CAPTURE ######################################
################################################################################

prod4 <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
prod4 = prod4[prod4$TECHNOLOGY=='COCSPN2' | prod4$TECHNOLOGY=='NGCSPN2' | prod4$TECHNOLOGY=='BMCSPN2',]
prod4 = prod4[prod4$FUEL=='E2' | prod4$FUEL=='E1',]
prod4[prod4$FUEL=="E1",]$value = 0.95*prod4[prod4$FUEL=="E1",]$value


{
  x11()
  ggplot(prod4[prod4$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECHNOLOGY)) +
    labs(title = "prod4uction by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() 
}

