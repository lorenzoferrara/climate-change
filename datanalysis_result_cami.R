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
prod = prod[prod$FUEL=="E1"]

prod$TECH=prod$TECHNOLOGY
for(i in unique(prod$TECHNOLOGY)){
  prod$TECH[prod$TECH==i] = substr(i, start=1, stop=2)
}

prod2 = prod |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
prod2$value = round(as.numeric(prod2$value),2)


{
  quartz()
  ggplot(prod2[prod2$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
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
################################################################################

# Last modified: Matteo Ghesini, 30/04/2023
