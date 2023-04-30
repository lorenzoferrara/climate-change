require(data.table)
require(tidyverse)
require(gdxtools)
require(witchtools)
require(ggpubr)

file_directory <- "~/GitHub/climate-change/Italy"
complete_directory <- here::here()
all_gdx <- c(Sys.glob(here::here(file_directory,"report_*.gdx")))

igdx('C:/GAMS/42')

osemosys_sanitize <- function(.x) {
  .x[, scen := basename(gdx)]
  .x[, scen := str_replace(scen,"report_","")]
  .x[, scen := str_replace(scen,".gdx","")]
  .x[, gdx := NULL]
  .x[, V1 := NULL]}

s_pes <- batch_extract("rep_pes_share",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
s_elec <- batch_extract("rep_elec_share",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

pes_tot <- batch_extract("rep_pes_tot",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
elec_tot <- batch_extract("rep_elec_tot",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
fen_tot <- batch_extract("rep_fen_tot",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

################################################################################
########### PLOT SHARE OF FUEL USED ############################################
################################################################################

{
  x11()
  ggplot(s_pes) + labs(title = "share of primary energy sources [%]") +
  geom_area(aes(x=as.numeric(y),y=value,fill=f)) +
  facet_wrap(scen~.,) + xlab("year") + ylab("share [%]") + theme_pubr()  
}

################################################################################
########### PLOT SHARE OF ELECTRICITY PRODUCED BYFUEL ##########################
################################################################################

{
  x11()
  ggplot(s_elec) + labs(title = "share of electricity production by primary energy source [%]") +
  geom_area(aes(x=as.numeric(y),y=value,fill=f)) +
  facet_wrap(scen~.,) + xlab("year") + ylab("share [%]") + theme_pubr() 
}

################################################################################
########### AMOUNT OF ENERGY ###################################################
################################################################################

tot_en <- full_join(fen_tot  %>% rename(final_energy=value), 
                    pes_tot %>% rename(fuel_supply=value)) %>%
          full_join(elec_tot %>% rename(elec_prod=value))

{
  x11()
  ggplot(tot_en %>% pivot_longer(c(fuel_supply,elec_prod,final_energy))) + 
    labs(title = "Amount of energy [PJ/yr]", subtitle = "total final energy, total primary energy supply, total electricity production") + 
    geom_line(aes(x=as.numeric(y),y=value,color=name)) + 
    xlab("year") + ylab("value [PJ]") + 
    facet_wrap(scen~.,)
}

{
  x11()
  ggplot(tot_en %>% pivot_longer(c(fuel_supply,elec_prod,final_energy))) + 
    labs(title = "Amount of energy [PJ/yr]", subtitle = "total final energy, total primary energy supply, total electricity production") + 
    geom_line(aes(x=as.numeric(y),y=value,color=scen)) + 
    xlab("year") + ylab("value [PJ]") + 
    facet_wrap(name~.,)
}

################################################################################
########### EFFICENCY AND SHARE OF FUEL USED FOR ELECTRICITY ? #################
################################################################################

{
  x11()
  ggplot(tot_en %>% 
           mutate(efficiency=final_energy/fuel_supply,elec_share=elec_prod/fuel_supply) %>% 
           pivot_longer(c(efficiency,elec_share))) +
    labs(title = "Miscellanious [%]", subtitle = "Efficency, Fuel used for electricity") +
    geom_line(aes(x=as.numeric(y),y=value,color=scen), linewidth=1.5) + theme_bw() + 
    # ylim(c(0,1))  + 
    xlab("year") + ylab("value [%]") + 
    facet_wrap(name~.,)
}

############################################################################################
############################################################################################
############################################################################################

# Last modified: Matteo Ghesini, 30/04/2023
