setwd("/Users/cami/Documents/GitHub/climate-change/Italy")
require(data.table)
require(witchtools)
require(ggpubr)
library(tidyverse)
library(gdxtools)

igdx('/Library/Frameworks/GAMS.framework/Versions/42/Resources')
file_directory <- "Documents/GitHub/climate-change/Italy"
complete_directory <- here::here()
#"/Users/cami/Documents/GitHub/climate-change"
all_gdx <- c(Sys.glob(here::here(file_directory,"results_*.gdx")))
all_gdx

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

ggplot(s_pes) +
  geom_area(aes(x=as.numeric(y),y=value,fill=f)) +
  facet_wrap(scen~.,) + xlab("year") + ylab("share %") + theme_pubr() 
{quartz()
ggplot(s_elec) +
  geom_area(aes(x=as.numeric(y),y=value,fill=f)) +
  facet_wrap(scen~.,) + xlab("year") + ylab("share %") + theme_pubr() 
  }

tot_en <- full_join(fen_tot  %>% rename(fen=value), 
                    pes_tot %>% rename(pes=value)) %>%
          full_join(elec_tot %>% rename(el=value))
  
ggplot(tot_en %>% pivot_longer(c(pes,el,fen))) +
  geom_line(aes(x=as.numeric(y),y=value,color=name))
  
ggplot(tot_en %>% 
         mutate(eff=fen/pes,el_share=el/pes) %>% 
         pivot_longer(c(eff,el_share))) +
  geom_line(aes(x=as.numeric(y),y=value,color=scen,linetype=name), linewidth=2) + theme_pubr() + ylim(c(0,1))

