
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
########### PLOT EMISSIONS #####################################################
################################################################################

emissions <- batch_extract("ANNUALEMISSIONS",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
emissions = emissions[emissions$YEAR <= 2050,]
emissions = emissions[emissions$scen != 'base']

{
  x11()
  p = ggplot(emissions |> filter(EMISSION=="CO2")) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1)+ 
    labs(title = "Annual Emissions", x = "year", y = "Emission [MtonCo2]") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"AnnualEmissions.png"), p)
}

################################################################################
########### PLOT PRODUCTION BY TECHNOLOGY ######################################
################################################################################

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

# UNIFY THE THE TWO TYPES OF ELECTRICITIES
prod = prod[prod$FUEL=="E1" | prod$FUEL=='E2',]
prod = prod[ prod$TECHNOLOGY  != "EL00TD0",]

#ACCOUNT FOR TRANSPORTATION LOSSES
prod[prod$FUEL=="E1",]$value = 0.95*prod[prod$FUEL=="E1",]$value 

#GROUP BY TYPE OF TECHNOLOGY
prod$TECH=prod$TECHNOLOGY
for(i in unique(prod$TECHNOLOGY)){
  prod$TECH[prod$TECH==i] = substr(i, start=1, stop=2) }
prod = prod |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
prod$value = round(as.numeric(prod$value),2)

prod=prod[prod$YEAR<=2050,]
prod=prod[prod$scen!='base',]

# ELIMINATE NON USED TECHNOLOGIES
prod2=prod
for(i in unique(prod2$TECH)){
  if( sum(prod2[prod2$TECH==i,]$value != 0) ==0 ){
    prod2 = prod2[prod2$TECH!=i,]
  }
}

# PLOT PRODUCTION
{
  x11()
  p = ggplot(prod2) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Electricity production by Technology", subtitle = "") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"ProductionByTechnology.png"), p)
}

# COMPUTE PERCENTUAL SHARES
prod2$value_perc = prod2$value
for(year in unique(prod2$YEAR)){
  for(scenario in unique(prod2$scen)){
    prod2[prod2$YEAR==year & prod2$scen==scenario,]$value_perc = prod2[prod2$YEAR==year & prod2$scen==scenario,]$value/sum(prod2[prod2$YEAR==year & prod2$scen==scenario,]$value)
  }
}

# PLOT PRODUCTION MIX
{
  x11()
  p = ggplot(prod2) +
    geom_area(aes(x=as.numeric(YEAR),y=value_perc,fill=TECH)) +
    labs(title = "Share of production by Technology") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy Share") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"MixProduttivo.png"), p)
}

# PLOT OF SPECIFIC CASES
prod2_NoNuke = prod2[prod2$scen=="BH85",]
{
  x11()
  p = ggplot(prod2_NoNuke) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"ProductionByTechnologyNoNuke.png"), p)
}

prod2_Nuke = prod2[prod2$scen=="NH85",]
{
  x11()
  p = ggplot(prod2_Nuke) +
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
########### PLOT ACCUMULATED CAPACITY ##########################################
################################################################################

cap <- batch_extract("ACCUMULATEDNEWCAPACITY",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

#USELESS TECHNOLOGIES
cap = cap[cap$value!=99999,]   

#RIVER AND DELTA HAVE NO REAL "CAPACITY"
cap = cap[cap$TECHNOLOGY != 'RIVER' & cap$TECHNOLOGY != 'DELTA',]   

#GROUP BY TYPE OF TECHNOLOGY
cap$TECH=cap$TECHNOLOGY
for(i in unique(cap$TECHNOLOGY)){
  cap$TECH[cap$TECH==i] = substr(i, start=1, stop=2) }
cap = cap |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
cap$value = round(as.numeric(cap$value),2)

# ELIMINATE NON USED TECHNOLOGIES
for(i in unique(cap$TECH)){
  if( sum(cap[cap$TECH==i,]$value != 0) ==0 ){
    cap = cap[cap$TECH!=i,]
  }
}

cap = cap[cap$YEAR <= 2050,]
cap = cap[cap$scen != 'base',]
cap = cap[cap$TECH != 'SE',]


{
  x11()
  p = ggplot(cap) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() +
    labs(title="Total Installed Capacity")
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

totcap$TECH=totcap$TECHNOLOGY

for(i in unique(totcap$TECHNOLOGY)){
  totcap$TECH[totcap$TECH==i] = substr(i, start=1, stop=2)
}

totcap = totcap |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
totcap$value = round(as.numeric(totcap$value),2)

totcap = totcap[totcap$YEAR <= 2050,]
totcap = totcap[totcap$scen != 'base',]

{
  x11()
  p = ggplot(totcap[totcap$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    scale_fill_brewer(palette="Paired") +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() +
    labs(title="Total Installed Capacity") +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"TotalCapacity.png"), p)
}

################################################################################
########### PLOT WATER USAGE ###################################################
################################################################################

METTERE

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
use2 <- batch_extract("USEANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
use2 = use2[use2$FUEL=="HY",]
use2 = use2[use2$YEAR<=2050,]
use2 = use2[use2$scen!='base',]

{
  x11()
  p = ggplot(use2) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1.3) +
    labs(title = "Total Water Usage") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Water [km3]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) + 
    ylim(0,600)
  
  print(p)
  ggsave(paste0(directory_graphs,"TotalWaterUsage.png"), p)
}

keep85 = c('BL85', 'BM85', 'BH85', 'NL85', 'NM85', 'NH85')
use2_85 = use2[use2$scen %in% keep85,]
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

#SEA WATER
use3 <- batch_extract("USEANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
use3 = use3[use3$FUEL=="SE",]
use3 = use3[use3$YEAR<=2050,]
use3 = use3[use3$scen!='base',]

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
  ggsave(paste0(directory_graphs,"TotalAnnualCost.png"), p)
  
}

# DIVISION BY NUCLEAR 
cost$NUCLEAR = substr(cost$scen,1,1)
cost$NUCLEAR[cost$NUCLEAR == 'N']='YES'
cost$NUCLEAR[cost$NUCLEAR == 'B']='NO'

#COST GROUPED BY NUCLEAR/NO-NUCLEAR
{
  x11()
  p = ggplot(cost) +
    geom_line(aes(x=as.numeric(YEAR),y=value/1000,group=scen, color=NUCLEAR), linewidth=1.1) +
    labs(title = "Total Annual Cost") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Cost [BIllions of $]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  print(p)
  ggsave(paste0(directory_graphs,"TotalAnnualCost.pngByNuclear.png"), p)
}

################################################################################
########### HYDRO Vs SEA #######################################################
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

################################################################################
########### PLOT PIE CHARTS ####################################################
################################################################################

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

# UNIFY THE THE TWO TYPES OF ELECTRICITIES
prod = prod[prod$FUEL=="E1" | prod$FUEL=='E2',]
prod = prod[ prod$TECHNOLOGY  != "EL00TD0",]

#ACCOUNT FOR TRANSPORTATION LOSSES
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

for(i in unique(prod$TECH)){
  if( sum(prod[prod$TECH==i,]$value != 0) ==0 ){
    prod = prod[prod$TECH!=i,]
  }
}

for(i in 1:length(legend[,1])){
  prod$TECH[prod$TECH==legend[i,1]] = legend[i,2]
}

prod$value_perc = prod$value
for(year in unique(prod$YEAR)){
  print(year)
  for(scenario in unique(prod$scen)){
    prod[prod$YEAR==year & prod$scen==scenario,]$value_perc = prod[prod$YEAR==year & prod$scen==scenario,]$value/sum(prod[prod$YEAR==year & prod$scen==scenario,]$value)
  }
}

keep_pie = c('BH85','NH85')
prod2050 = prod[prod$YEAR==2050 & prod$scen %in% keep_pie,]
prod2015 = prod[prod$YEAR==2015 & prod$scen==prod[1,]$scen,]

{
  x11()
  p = ggplot(prod2015, aes(x = "", y = value_perc, fill = TECH)) +
    geom_bar(stat = "identity", width = 1, color='black') +
    geom_segment(aes(x = 0, y = 0, xend = 0, yend = value_perc), color = "black", size = 0.5) +
    coord_polar("y", start = 0) +
    # facet_wrap(scen~.,) +
    labs(fill = "Technology", title = "Productive Mix in 2015") +
    ylab("") + xlab("") +
    geom_text(data =prod2015[prod2015$value_perc>=1e-2,], aes(label = paste0(round(value_perc*100), "%")), position = position_stack(vjust = 0.5)) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5),
          axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank())
  
  print(p)
  ggsave(paste0(directory_graphs,"MixProduttivoPie2015.png"), p)
}

{
  x11()
  p = ggplot(prod2050, 
             aes(x = "", y = value_perc, fill = TECH)) +
    geom_bar(stat = "identity", width = 1, color='black') +
    geom_segment(aes(x = 0, y = 0, xend = 0, yend = value_perc), color = "black", size = 0.5) +
    coord_polar("y", start = 0) +
    facet_wrap(scen~.,) +
    labs(fill = "Technology", title = "Productive Mix in 2050") +
    ylab("") + xlab("") +
    geom_text(data =prod2050[prod2050$value_perc>=1e-2,], aes(label = paste0(round(value_perc*100), "%")), position = position_stack(vjust = 0.5)) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5),
          axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank())
  
  print(p)
  ggsave(paste0(directory_graphs,"MixProduttivoPie2015.png"), p)
}
