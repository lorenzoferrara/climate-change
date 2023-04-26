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
for(i in 1:length(temp)){
  prod$TECH[i] = substr(temp[i], start=1, stop=2)
  print(i)
}

prod2=matrix(0,(60-15+1)*length(unique(prod$TECH)),3)
k=1
for(i in 2015:2060){
  for(j in unique(prod$TECH)){          
    prod2[k,1] = i
    prod2[k,2] = j
    prod2[k,3] = sum(prod[prod$YEAR==i & prod$TECH==j,5])
    k=k+1
  }
}
prod2=as.data.frame(prod2)
colnames(prod2)=c('YEAR', 'TECH', 'value')
prod2$value = as.numeric(round(prod2$value), 2)
{
  x11()
  ggplot(prod2[prod2$value!=0,]) +
  # ggplot(prod2) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    # facet_wrap(scen~.,) + 
    xlab("year") + ylab("POWER [GW]") + theme_pubr() 
}

################################################################################################
#ACCUMULATED CAPACITY


