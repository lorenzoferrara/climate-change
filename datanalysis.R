require(data.table)
require(tidyverse)
require(gdxtools)
require(witchtools)
require(ggpubr)

file_directory <- "Utopia"
complete_directory <- here::here()
all_gdx <- c(Sys.glob(here::here(file_directory,"report_*.gdx")))

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

x11()
ggplot(s_pes) +
  geom_area(aes(x=as.numeric(y),y=value,fill=f)) +
  facet_wrap(scen~.,) + xlab("year") + ylab("share %") + theme_pubr() 

x11()
ggplot(s_elec) +
  geom_area(aes(x=as.numeric(y),y=value,fill=f)) +
  facet_wrap(scen~.,) + xlab("year") + ylab("share %") + theme_pubr() 

tot_en <- full_join(fen_tot  %>% rename(fen=value), 
                    pes_tot %>% rename(pes=value)) %>%
          full_join(elec_tot %>% rename(el=value))

x11()
ggplot(tot_en %>% pivot_longer(c(pes,el,fen))) +
  geom_line(aes(x=as.numeric(y),y=value,color=name))
  
x11()
ggplot(tot_en %>% 
         mutate(eff=fen/pes,el_share=el/pes) %>% 
         pivot_longer(c(eff,el_share))) +
  geom_line(aes(x=as.numeric(y),y=value,color=scen,linetype=name), linewidth=2) + theme_pubr() + ylim(c(0,1))

#######################

all_gdx <- c(Sys.glob(here::here(file_directory,"results_*.gdx")))
all_gdx

osemosys_sanitize_2 <- function(.x) {
  .x[, scen := basename(gdx)]
  .x[, scen := str_replace(scen,"results_","")]
  .x[, scen := str_replace(scen,".gdx","")]
  .x[, gdx := NULL]
  # .x[, V1 := NULL]
  }

storaged_water <- batch_extract("StorageLevelYearFinish",all_gdx)[[1]] |> setDT() |> osemosys_sanitize_2()
x11()
ggplot(storaged_water) +
  geom_line(aes(x=as.numeric(YEAR),y=value,color=scen))

{x11()
ggplot(storaged_water) +
  geom_area(aes(x=as.numeric(YEAR),y=value)) +
  facet_wrap(scen~.,) + xlab("year") + ylab("storaged water") + theme_pubr() 
}
