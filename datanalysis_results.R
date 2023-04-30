require(data.table)
require(tidyverse)
require(gdxtools)
require(witchtools)
require(ggpubr)

file_directory <- "Italy"
complete_directory <- here::here()
#complete_directory = "C:/Users/ghesi/Documents/GitHub/climate-change"
all_gdx <- c(Sys.glob(here::here(file_directory,"results_*.gdx")))

osemosys_sanitize_2 <- function(.x) {
  .x[, scen := basename(gdx)]
  .x[, scen := str_replace(scen,"results_","")]
  .x[, scen := str_replace(scen,".gdx","")]
  .x[, gdx := NULL]
  # .x[, V1 := NULL]
  }

# storaged_water <- batch_extract("STORAGELEVELYEARFINISH",all_gdx)[[1]] |> setDT() |> osemosys_sanitize_2()
# {x11()
#   ggplot(storaged_water) +
#     geom_line(aes(x=as.numeric(YEAR),y=value,color=scen))
# }

emissions <- batch_extract("ANNUALEMISSIONS",all_gdx)[[1]] |> setDT() |> osemosys_sanitize_2()
{
  x11()
  ggplot(emissions |> filter(EMISSION=="CO2")) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen))+ 
    labs(title = "Emissions", x = "year", y = "Emission [MtonCo2]") +
    theme_bw()
}


############################################################################
# PRODUCTIONBYTECHNOLOGYANNUAL

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize_2()
prod = prod[prod$FUEL=="E1"]

prod$TECH=prod$TECHNOLOGY
for(i in unique(prod$TECHNOLOGY)){
  prod$TECH[prod$TECH==i] = substr(i, start=1, stop=2)
}

prod3 = prod |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
prod3$value = round(as.numeric(prod3$value),2)


{
  x11()
  ggplot(prod3[prod3$value!=0,]) +
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
}

cap2 = cap |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
cap2$value = round(as.numeric(cap3$value),2)


{
  x11()
  ggplot(cap2[cap2$value!=0,]) +
    # ggplot(cap2) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() 
}
