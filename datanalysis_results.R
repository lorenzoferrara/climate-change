require(data.table)
require(tidyverse)
require(gdxtools)
require(witchtools)
require(ggpubr)

file_directory <- "Italy"
complete_directory <- here::here()
#complete_directory = "C:/Users/ghesi/Documents/GitHub/climate-change"
all_gdx <- c(Sys.glob(here::here(file_directory,"results_*.gdx")))
all_gdx

osemosys_sanitize_2 <- function(.x) {
  .x[, scen := basename(gdx)]
  .x[, scen := str_replace(scen,"results_","")]
  .x[, scen := str_replace(scen,".gdx","")]
  .x[, gdx := NULL]
  # .x[, V1 := NULL]
  }

storaged_water <- batch_extract("STORAGELEVELYEARFINISH",all_gdx)[[1]] |> setDT() |> osemosys_sanitize_2()
{x11()
  ggplot(storaged_water) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen))
}

emissions <- batch_extract("ANNUALEMISSIONS",all_gdx)[[1]] |> setDT() |> osemosys_sanitize_2()
{
  # x11()
  ggplot(emissions[emissions$EMISSION=="CO2"]) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen))
}


############################################################################
# PRODUCTIONBYTECHNOLOGYANNUAL

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize_2()
prod = prod[prod$FUEL=="E1"]

temp = prod$TECHNOLOGY
prod$TECH=temp

for(i in unique(temp)){
  
  prod$TECH[prod$TECH==i] = substr(i, start=1, stop=2)
  print(i)
}

prod2=matrix(0,(60-15+1)*length(unique(prod$TECH))*length(unique(prod$scen)),4)
k=1
for(year in 2015:2060){
  for(technology in unique(prod$TECH)){
    for(scenario in unique(prod$scen)){
      prod2[k,1] = year
      prod2[k,2] = technology
      prod2[k,3] = sum(prod[prod$YEAR==year & prod$TECH==technology & prod$scen==scenario,5])
      prod2[k,4] = scenario
      k=k+1
    }
  }
}
prod2=as.data.frame(prod2)
colnames(prod2)=c('YEAR', 'TECH', 'value', 'scen')
prod2$value = round(as.numeric(prod2$value),2)
{
  x11()
  ggplot(prod2[prod2$value!=0,]) +
  # ggplot(prod2) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() 
}

################################################################################################
#ACCUMULATED CAPACITY


cap <- batch_extract("ACCUMULATEDNEWCAPACITY",all_gdx)[[1]] |> setDT() |> osemosys_sanitize_2()
cap = cap[cap$value!=99999]

temp = cap$TECHNOLOGY
cap$TECH=temp

for(i in unique(temp)){
  cap$TECH[cap$TECH==i] = substr(i, start=1, stop=2)
  print(i)
}

cap2=matrix(0,(60-15+1)*length(unique(cap$TECH))*length(unique(cap$scen)),4)
k=1
for(year in 2015:2060){
  for(technology in unique(cap$TECH)){
    for(scenario in unique(cap$scen)){
      cap2[k,1] = year
      cap2[k,2] = technology
      cap2[k,3] = sum(cap[cap$YEAR==year & cap$TECH==technology & cap$scen==scenario,]$value)
      cap2[k,4] = scenario
      k=k+1
    }
  }
}
cap2=as.data.frame(cap2)
colnames(cap2)=c('YEAR', 'TECH', 'value', 'scen')
cap2$value = round(as.numeric(cap2$value),2)
{
  x11()
  ggplot(cap2[cap2$value!=0,]) +
    # ggplot(cap2) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() 
}

