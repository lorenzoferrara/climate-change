
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

directory_graphs = "~/GitHub/climate-change/Italy/Plots/Water/"

################################################################################
##### CREATION OF THE LEGEND ###################################################
################################################################################

legend = cbind( c("BF", "BM", "CO", "EL", "GO", "HF", "HY", "NG", "OC", "OI", "SO", "WI", "WS", "NU", "UR", "BA", "RI", "SE", "DE"), 
                c("BioFuel", "Biomass", "Coal", "Trasformator", "Geothermal", "HevayFuel", "Hydro", "NaturalGas", "Tidal", 
                  "Oil", "Solar", "Wind", "Waste", "Nuclear", "Uranium", "Batteries", "River", "Sea", "Delta"))

# LINES TO CONVERT LEGEND
# for(i in 1:length(legend[,1])){
#   prod$TECH[prod$TECH==legend[i,1]] = legend[i,2]
# }

################################################################################
########### PLOT FRESH WATER USAGE #############################################
################################################################################

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
prod = prod[prod$FUEL=="E1" | prod$FUEL=='E2',]
prod = prod[ prod$TECHNOLOGY  != "EL00TD0",]
prod[prod$FUEL=="E1",]$value = 0.95*prod[prod$FUEL=="E1",]$value

prod=prod[prod$YEAR<=2050,]
prod=prod[prod$scen!='base',]

input <- batch_extract("InputActivityRatio",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
output <- batch_extract("OutputActivityRatio",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

input_hy = input[input$FUEL=="HY",]
output_hy = output[output$FUEL=="HY",]

input_hy = input_hy |> 
  group_by(TECHNOLOGY) |>
  summarise(value = mean(value))

output_hy = output_hy |> 
  group_by(TECHNOLOGY) |>
  summarise(value = mean(value))

prod_hy = prod

prod_hy$water=prod_hy$value
for(i in unique(prod_hy$TECHNOLOGY)){
  if(i %in% input_hy$TECHNOLOGY){
    ii = input_hy$value[input_hy$TECHNOLOGY==i]
  } else{
    ii = 0
  }
  if(i %in% output_hy$TECHNOLOGY){
    oo = output_hy$value[output_hy$TECHNOLOGY==i]
  } else{
    oo = 0
  }
  prod_hy$water[prod_hy$TECHNOLOGY==i] = prod_hy$value[prod_hy$TECHNOLOGY==i] * (ii-oo)
}

prod_hy$TECH=prod_hy$TECHNOLOGY
for(i in unique(prod_hy$TECHNOLOGY)){
  prod_hy$TECH[prod_hy$TECH==i] = substr(i, start=1, stop=2)
}

prod_hy = prod_hy |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(water))
prod_hy$value = round(as.numeric(prod_hy$value),2)

{
  x11()
  p = ggplot(prod_hy[prod_hy$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Fresh water usage divided by technology") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"FreshWaterUsedByTechnology.png"), p)
}

freshwater = prod_hy |> 
  group_by(scen,YEAR) |>
  summarise(value = sum(value))

################################################################################
########### PLOT SALT WATER USAGE ##############################################
################################################################################

input_se = input[input$FUEL=="SE",]
output_se = output[output$FUEL=="SE",]

input_se = input_se |> 
  group_by(TECHNOLOGY) |>
  summarise(value = mean(value))

output_se = output_se |> 
  group_by(TECHNOLOGY) |>
  summarise(value = mean(value))

prod_se = prod

prod_se$water=prod_se$value
for(i in unique(prod_se$TECHNOLOGY)){
  if(i %in% input_se$TECHNOLOGY){
    ii = input_se$value[input_se$TECHNOLOGY==i]
  } else{
    ii = 0
  }
  if(i %in% output_se$TECHNOLOGY){
    oo = output_se$value[output_se$TECHNOLOGY==i]
  } else{
    oo = 0
  }
  prod_se$water[prod_se$TECHNOLOGY==i] = prod_se$value[prod_se$TECHNOLOGY==i] * (ii-oo)
}

prod_se$TECH=prod_se$TECHNOLOGY
for(i in unique(prod_se$TECHNOLOGY)){
  prod_se$TECH[prod_se$TECH==i] = substr(i, start=1, stop=2)
}

prod_se = prod_se |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(water))
prod_se$value = round(as.numeric(prod_se$value),2)

{
  x11()
  p = ggplot(prod_se[prod_se$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Salt water usage divided by technology") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"SeaWaterUsedByTechnology.png"), p)
}

seawater = prod_se |> 
  group_by(scen,YEAR) |>
  summarise(value = sum(value))

################################################################################
########### PLOT FRESH VS SALT WATER USAGE #####################################
################################################################################

scenari = c('BH85', 'BL26', 'NH85', 'NL26')
{
  x11()
  p = ggplot(freshwater[freshwater$scen%in% scenari,]) +
    geom_line(aes(x=as.numeric(YEAR),y=value), color='lightblue', linewidth=1.5)+ 
    geom_line(data=seawater[seawater$scen%in% scenari,], aes(x=as.numeric(YEAR),y=value), color='blue', linewidth=1.5)+
    facet_wrap(scen~.,) +
    theme_bw() + 
    labs(title = "Water usage divided by type", x = "", y = "Water [10^9 m3]", color="WATER TYPE") +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"RivervsSeaUses.png"), p)
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
    geom_line(aes(x=as.numeric(DATE),y=value,color=STORAGE), linewidth=1) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"StorageUsage.png"), p)
}

# SOME SPECIFIC SCENARIOS
storage = storage[storage$STORAGE != "BAT",]
keep85 = c('BL85', 'BM85', 'BH85', 'NL85', 'NM85', 'NH85')
storage_85 = storage[storage$scen %in% keep85,]
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

#RIVER WATER
use_hy <- batch_extract("USEANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
use_hy = use_hy[use_hy$FUEL=="HY",]
use_hy = use_hy[use_hy$YEAR<=2050,]
use_hy = use_hy[use_hy$scen!='base',]

{
  x11()
  p = ggplot(use_hy) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1.3) +
    labs(title = "Total Fresh Water Usage") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Water [km3]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) + 
    ylim(0,600)
  
  print(p)
  ggsave(paste0(directory_graphs,"TotalWaterUsage.png"), p)
}

# PLOT OF THE 8.5 SCENARIO
keep85 = c('BL85', 'BM85', 'BH85', 'NL85', 'NM85', 'NH85')
use_hy__85 = use_hy[use_hy$scen %in% keep85,]
{
  x11()
  p = ggplot(use_hy__85) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1.3) +
    #facet_wrap(scen~.,) +
    labs(title = "Adaptation to RCP 8.5") +
    xlab("year") + ylab("Fresh water used [10^9 m3]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) + 
    ylim(0,600)
  print(p)
  ggsave(paste0(directory_graphs,"TotalWaterUsage_85.png"), p)
}

#SEA WATER
use_se <- batch_extract("USEANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
use_se = use_se[use_se$FUEL=="SE",]
use_se = use_se[use_se$YEAR<=2050,]
use_se = use_se[use_se$scen!='base',]

{
  x11()
  p = ggplot(use_se) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1.3) +
    labs(title = "Total Sea Water Usage") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Water [km3]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  print(p)
  ggsave(paste0(directory_graphs,"TotalSeaWaterUsage.png"), p)
}

################################################################################
########### PLOT FRESH VS SALT WATER ELECTRICITY PRODUCTION ####################
################################################################################

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

# UNIFY THE THE TWO TYPES OF ELECTRICITIES
prod = prod[prod$FUEL=="E1" | prod$FUEL=='E2',]
prod = prod[ prod$TECHNOLOGY  != "EL00TD0",]

#ACCOUNT FOR TRANSPORTATION LOSSES
prod[prod$FUEL=="E1",]$value = 0.95*prod[prod$FUEL=="E1",]$value 

for(i in unique(prod$TECHNOLOGY)){
  prod$TYPE[prod$TECHNOLOGY==i] = substr(i, start=nchar(i), stop=nchar(i))
}
prod$TYPE[prod$TYPE!='S'] = 'freshwater'
prod$TYPE[prod$TYPE=='S'] = 'sea water'

prod = prod |> 
  group_by(YEAR, scen, TYPE) |>
  summarise(value = sum(value))
prod$value = round(as.numeric(prod$value),2)


prod = prod[prod$YEAR <= 2050,]
prod = prod[prod$scen != 'base',]

{
  x11()
  p = ggplot(prod[prod$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value, fill=TYPE)) +
    labs(title = "Electricity production by water TYPE used [PJ/yr]") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() +
    scale_fill_brewer(palette="Paired") +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"RiverVSSeaEnergy.png"), p)
}
