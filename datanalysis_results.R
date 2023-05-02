
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
    xlab("year") + ylab("Production [GW]") + theme_pubr()  
}


################################################################################
########### PLOT WATER USAGE ###################################################
################################################################################

water <- batch_extract("USEANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
water = water[water$FUEL=='SE' | water$FUEL=='HY']

{
  x11()
  ggplot(water) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=FUEL), linewidth=1.5) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Water used [ML]") + theme_pubr() 
}
